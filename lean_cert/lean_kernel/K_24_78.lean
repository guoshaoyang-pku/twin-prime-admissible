import Sound
import lean_certs.cert_24_78

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_78_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 24) (d := 78) (c := cert_24_78) (by decide)
