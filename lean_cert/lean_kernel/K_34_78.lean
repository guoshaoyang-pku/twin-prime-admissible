import Sound
import lean_certs.cert_34_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_78_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 34) (d := 78) (c := cert_34_78) (by decide)
