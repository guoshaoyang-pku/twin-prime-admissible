import Sound
import lean_certs.cert_25_70

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_70_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 25) (d := 70) (c := cert_25_70) (by decide)
