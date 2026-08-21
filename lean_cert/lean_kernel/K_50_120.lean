import Sound
import lean_certs.cert_50_120

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_120_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 50) (d := 120) (c := cert_50_120) (by decide)
