import Sound
import lean_certs.cert_13_44

open CertVerify

theorem H13_gt_44 : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 44 := by
  exact certValidRoot_sound (k := 13) (d := 44) (c := cert_13_44) (by native_decide)
