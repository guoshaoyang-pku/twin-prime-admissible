import Sound
import lean_certs.cert_38_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_78_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 38) (d := 78) (c := cert_38_78) (by decide)
