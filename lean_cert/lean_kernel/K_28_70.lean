import Sound
import lean_certs.cert_28_70

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_70_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 28) (d := 70) (c := cert_28_70) (by decide)
