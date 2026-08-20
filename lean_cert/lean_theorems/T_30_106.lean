import Sound
import lean_certs.cert_30_106

open CertVerify

theorem H30_gt_106 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 30) (d := 106) (c := cert_30_106) (by native_decide)
