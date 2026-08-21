import Sound
import lean_certs.cert_14_44

open CertVerify

theorem H14_gt_44 : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 14) (d := 44) (c := cert_14_44) (by native_decide)
