import Sound
import lean_certs.cert_18_44

open CertVerify

theorem H18_gt_44 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 18) (d := 44) (c := cert_18_44) (by native_decide)
