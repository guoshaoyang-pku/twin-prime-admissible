import Sound
import lean_certs.cert_44_150

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_150_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 44) (d := 150) (c := cert_44_150) (by decide)
