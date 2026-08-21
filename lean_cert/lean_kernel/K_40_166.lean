import Sound
import lean_certs.cert_40_166

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_166_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 40) (d := 166) (c := cert_40_166) (by decide)
