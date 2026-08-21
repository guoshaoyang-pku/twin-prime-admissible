import Sound
import lean_certs.cert_49_210

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H49_gt_210_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 210 := by
  exact certValidRoot_sound (k := 49) (d := 210) (c := cert_49_210) (by decide)
