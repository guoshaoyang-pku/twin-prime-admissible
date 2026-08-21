import Sound
import lean_certs.cert_48_166

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_166_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 48) (d := 166) (c := cert_48_166) (by decide)
