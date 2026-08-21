import Sound
import lean_certs.cert_21_44

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_44_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 21) (d := 44) (c := cert_21_44) (by decide)
