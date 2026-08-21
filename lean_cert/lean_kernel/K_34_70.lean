import Sound
import lean_certs.cert_34_70

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_70_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 34) (d := 70) (c := cert_34_70) (by decide)
