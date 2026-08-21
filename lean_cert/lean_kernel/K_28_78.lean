import Sound
import lean_certs.cert_28_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_78_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 28) (d := 78) (c := cert_28_78) (by decide)
