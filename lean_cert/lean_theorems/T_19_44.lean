import Sound
import lean_certs.cert_19_44

open CertVerify

theorem H19_gt_44 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 19) (d := 44) (c := cert_19_44) (by native_decide)
