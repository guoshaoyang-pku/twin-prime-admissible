import Sound
import lean_certs.cert_46_120

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_120_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 46) (d := 120) (c := cert_46_120) (by decide)
