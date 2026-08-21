import Sound
import lean_certs.cert_31_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H31_gt_78_kernel : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 31) (d := 78) (c := cert_31_78) (by decide)
