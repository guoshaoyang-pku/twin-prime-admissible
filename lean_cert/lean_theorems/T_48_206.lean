import Sound
import lean_certs.cert_48_206

open CertVerify

theorem H48_gt_206 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 206 := by
  exact certValidRoot_sound (k := 48) (d := 206) (c := cert_48_206) (by native_decide)
