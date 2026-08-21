import Sound
import lean_certs.cert_46_100

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_100_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 100 := by
  exact certValidRoot_sound (k := 46) (d := 100) (c := cert_46_100) (by decide)
