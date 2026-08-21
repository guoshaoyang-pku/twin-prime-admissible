import Sound
import lean_certs.cert_45_120

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_120_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 45) (d := 120) (c := cert_45_120) (by decide)
