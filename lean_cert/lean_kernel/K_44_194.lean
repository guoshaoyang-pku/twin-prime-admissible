import Sound
import lean_certs.cert_44_194

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H44_gt_194_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 194 := by
  exact certValidRoot_sound (k := 44) (d := 194) (c := cert_44_194) (by decide)
