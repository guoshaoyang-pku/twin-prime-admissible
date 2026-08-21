import Sound
import lean_certs.cert_23_70

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H23_gt_70_kernel : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 23) (d := 70) (c := cert_23_70) (by decide)
