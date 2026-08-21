import Sound
import lean_certs.cert_43_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_110_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 43) (d := 110) (c := cert_43_110) (by decide)
