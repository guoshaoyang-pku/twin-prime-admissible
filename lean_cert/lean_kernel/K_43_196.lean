import Sound
import lean_certs.cert_43_196

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H43_gt_196_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 196 := by
  exact certValidRoot_sound (k := 43) (d := 196) (c := cert_43_196) (by decide)
