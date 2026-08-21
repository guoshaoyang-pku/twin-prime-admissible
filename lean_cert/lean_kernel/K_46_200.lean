import Sound
import lean_certs.cert_46_200

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H46_gt_200_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 200 := by
  exact certValidRoot_sound (k := 46) (d := 200) (c := cert_46_200) (by decide)
