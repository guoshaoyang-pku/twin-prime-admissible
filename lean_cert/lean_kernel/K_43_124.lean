import Sound
import lean_certs.cert_43_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_124_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 43) (d := 124) (c := cert_43_124) (by decide)
