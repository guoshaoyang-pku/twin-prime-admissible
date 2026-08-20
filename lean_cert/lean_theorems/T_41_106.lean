import Sound
import lean_certs.cert_41_106

open CertVerify

theorem H41_gt_106 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 41) (d := 106) (c := cert_41_106) (by native_decide)
