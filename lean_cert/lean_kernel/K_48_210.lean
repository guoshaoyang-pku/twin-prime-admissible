import Sound
import lean_certs.cert_48_210

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H48_gt_210_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 210 := by
  exact certValidRoot_sound (k := 48) (d := 210) (c := cert_48_210) (by decide)
