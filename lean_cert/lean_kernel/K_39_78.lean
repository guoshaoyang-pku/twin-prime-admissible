import Sound
import lean_certs.cert_39_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H39_gt_78_kernel : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 39) (d := 78) (c := cert_39_78) (by decide)
