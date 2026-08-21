import Sound
import lean_certs.cert_41_180

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H41_gt_180_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 180 := by
  exact certValidRoot_sound (k := 41) (d := 180) (c := cert_41_180) (by decide)
