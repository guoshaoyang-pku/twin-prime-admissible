import Sound
import lean_certs.cert_29_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_110_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 29) (d := 110) (c := cert_29_110) (by decide)
