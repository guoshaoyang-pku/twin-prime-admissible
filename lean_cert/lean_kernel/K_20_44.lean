import Sound
import lean_certs.cert_20_44

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H20_gt_44_kernel : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 20) (d := 44) (c := cert_20_44) (by decide)
