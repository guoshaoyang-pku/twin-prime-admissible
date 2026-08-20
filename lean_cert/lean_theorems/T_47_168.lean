import Sound
import lean_certs.cert_47_168

open CertVerify

theorem H47_gt_168 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 47) (d := 168) (c := cert_47_168) (by native_decide)
