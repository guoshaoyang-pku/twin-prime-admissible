import Sound
import lean_certs.cert_16_44

open CertVerify

theorem H16_gt_44 : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 16) (d := 44) (c := cert_16_44) (by native_decide)
