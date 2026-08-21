import Sound
import lean_certs.cert_13_44

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H13_gt_44_kernel : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 13) (d := 44) (c := cert_13_44) (by decide)
