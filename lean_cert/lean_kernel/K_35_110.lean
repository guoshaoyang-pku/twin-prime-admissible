import Sound
import lean_certs.cert_35_110

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_110_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 110 := by
  exact certValidRoot_sound (k := 35) (d := 110) (c := cert_35_110) (by decide)
