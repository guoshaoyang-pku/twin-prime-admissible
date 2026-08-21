import Sound
import lean_certs.cert_44_200

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H44_gt_200_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 200 := by
  exact certValidRoot_sound (k := 44) (d := 200) (c := cert_44_200) (by decide)
