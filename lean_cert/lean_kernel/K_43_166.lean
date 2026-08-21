import Sound
import lean_certs.cert_43_166

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_166_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 166 := by
  exact certValidRoot_sound (k := 43) (d := 166) (c := cert_43_166) (by decide)
