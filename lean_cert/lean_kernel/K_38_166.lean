import Sound
import lean_certs.cert_38_166

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H38_gt_166_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 38) (d := 166) (c := cert_38_166) (by decide)
