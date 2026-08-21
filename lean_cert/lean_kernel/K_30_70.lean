import Sound
import lean_certs.cert_30_70

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_70_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 30) (d := 70) (c := cert_30_70) (by decide)
