import Sound
import lean_certs.cert_46_180

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_180_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 46) (d := 180) (c := cert_46_180) (by decide)
