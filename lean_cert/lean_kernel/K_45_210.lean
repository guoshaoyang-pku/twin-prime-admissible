import Sound
import lean_certs.cert_45_210

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H45_gt_210_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 210 := by
  exact certValidRoot_sound (k := 45) (d := 210) (c := cert_45_210) (by decide)
