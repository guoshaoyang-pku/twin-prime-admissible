import Sound
import lean_certs.cert_50_210

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_210_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 210 := by
  exact certValidRoot_sound (k := 50) (d := 210) (c := cert_50_210) (by decide)
