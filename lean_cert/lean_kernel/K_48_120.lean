import Sound
import lean_certs.cert_48_120

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_120_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 120 := by
  exact certValidRoot_sound (k := 48) (d := 120) (c := cert_48_120) (by decide)
