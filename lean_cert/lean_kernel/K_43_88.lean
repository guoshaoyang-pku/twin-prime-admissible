import Sound
import lean_certs.cert_43_88

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H43_gt_88_kernel : ¬ ∃ t : List Nat, admissible 43 t = true ∧ diameter t ≤ 88 := by
  exact certValidRoot_sound (k := 43) (d := 88) (c := cert_43_88) (by decide)
