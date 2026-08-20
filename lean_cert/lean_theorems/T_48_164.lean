import Sound
import lean_certs.cert_48_164

open CertVerify

theorem H48_gt_164 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 164 := by
  exact certValidRoot_sound (k := 48) (d := 164) (c := cert_48_164) (by native_decide)
