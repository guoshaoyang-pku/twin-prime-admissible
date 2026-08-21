import Sound
import lean_certs.cert_35_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H35_gt_78_kernel : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 35) (d := 78) (c := cert_35_78) (by decide)
