import Sound
import lean_certs.cert_49_180

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_180_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 49) (d := 180) (c := cert_49_180) (by decide)
