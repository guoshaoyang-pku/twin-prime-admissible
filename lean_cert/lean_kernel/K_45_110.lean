import Sound
import lean_certs.cert_45_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_110_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 45) (d := 110) (c := cert_45_110) (by decide)
