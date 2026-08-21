import Sound
import lean_certs.cert_44_186

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_186_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 186 := by
  exact certValidRoot_sound (k := 44) (d := 186) (c := cert_44_186) (by decide)
