import Sound
import lean_certs.cert_48_184

open CertVerify

theorem H48_gt_184 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 184 := by
  exact certValidRoot_sound (k := 48) (d := 184) (c := cert_48_184) (by native_decide)
