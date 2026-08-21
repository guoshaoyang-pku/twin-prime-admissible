import Sound
import lean_certs.cert_38_120

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_120_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 38) (d := 120) (c := cert_38_120) (by decide)
