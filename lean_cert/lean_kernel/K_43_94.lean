import Sound
import lean_certs.cert_43_94

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_94_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 43) (d := 94) (c := cert_43_94) (by decide)
